from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from pydantic import BaseModel
from typing import List
from sqlalchemy import text
from fastapi.responses import JSONResponse, RedirectResponse
from typing import Optional

DATABASE_URL = "postgresql+asyncpg://myuser:mypassword@localhost:5432/mydatabase"


engine = create_async_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(bind=engine, class_=AsyncSession, expire_on_commit=False)
Base = declarative_base()

app = FastAPI()

async def get_db():
    async with SessionLocal() as session:
        yield session
class UserCreate(BaseModel):
    id: str
    email: str
    name: str
    phone: str
    fcm: str
    avatar_id: int | None = None  # Avatar is optional

@app.post("/users/add", tags=["Users"])
async def create_user(user: UserCreate, db: AsyncSession = Depends(get_db)):
    query = text("""
        INSERT INTO users (id, email, name, phone, fcm, avatar_id) 
        VALUES (:id, :email, :name, :phone, :fcm, :avatar_id) 
        RETURNING id
    """)
    result = await db.execute(query, {
        "id": user.id,
        "email": user.email,
        "name": user.name,
        "phone": user.phone,
        "fcm": user.fcm,
        "avatar_id": user.avatar_id
    })
    user_id = result.scalar_one()
    await db.commit()
    return {"user_id": user_id}
# Pydantic модель для отримання користувача
class UserResponse(BaseModel):
    id: str
    email: str
    name: str
    phone: str
    fcm: str
    avatar_id: int | None
    
@app.get("/users/{user_id}", response_model=UserResponse, tags=["Users"])
async def get_user(user_id: str, db: AsyncSession = Depends(get_db)):
    query = text("SELECT id, email, name, phone, fcm, avatar_id FROM users WHERE id = :user_id")
    result = await db.execute(query, {"user_id": user_id})
    user = result.fetchone()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    name = user[2].decode('utf-8') if isinstance(user[2], bytes) else user[2]
    email = user[1].decode('utf-8') if isinstance(user[1], bytes) else user[1]
    phone = user[3].decode('utf-8') if isinstance(user[3], bytes) else user[3]
    fcm = user[4].decode('utf-8') if isinstance(user[4], bytes) else user[4]
    avatar_id = user[5].decode('utf-8') if isinstance(user[5], bytes) else user[5]

    user_response = UserResponse(
        id=user[0],          # id користувача
        email=email,         # email користувача
        name=name,           # ім'я користувача
        phone=phone,         # телефон користувача
        fcm=fcm,             # fcm користувача
        avatar_id=avatar_id  # avatar_id користувача (якщо є)
    )

    # Повертаємо відповідь з правильним кодуванням
    return JSONResponse(content=user_response.dict(), headers={"Content-Type": "application/json; charset=utf-8"})

# Модель для оновлення користувача
class UpdateUserRequest(BaseModel):
    phone: Optional[str] = None
    avatar_id: Optional[int] = None

@app.put("/users/{user_id}", tags=["Users"])
async def update_user(user_id: str, user_data: UpdateUserRequest, db: AsyncSession = Depends(get_db)):
    query = text("""
        UPDATE users SET phone = :phone, avatar_id = :avatar_id WHERE id = :user_id RETURNING id
    """)
    result = await db.execute(query, {
        "user_id": user_id,
        "phone": user_data.phone,
        "avatar_id": user_data.avatar_id
    })
    
    user = result.fetchone()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    await db.commit()
    
    return {"message": "User updated successfully", "user_id": user[0]}
  
@app.get("/", include_in_schema=False)
def docs_redirect():
    return RedirectResponse(url="/docs")

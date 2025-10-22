from fastapi import APIRouter, WebSocket
from app.utils.websocket_manager import manager

router = APIRouter(prefix="/ws")

@router.websocket("/queue")
async def queue_ws(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await manager.broadcast(f"Queue update: {data}")
    except:
        manager.disconnect(websocket)

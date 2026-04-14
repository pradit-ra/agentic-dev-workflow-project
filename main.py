from fastapi import FastAPI
import cowsay

app = FastAPI()


@app.get("/health")
async def health():
    return {"status": "healthy", "message": "System is operational"}


@app.get("/cow")
async def cow(text: str = "Moo"):
    output = cowsay.cow(text)
    return {"output": output}

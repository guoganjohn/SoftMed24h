import os
import redis
from dotenv import load_dotenv

load_dotenv()

class QueueService:
    def __init__(self):
        self.redis_url = os.getenv("REDIS_URL")
        self.redis = redis.from_url(self.redis_url)
        self.queue_name = "patient_queue"

    def add_to_queue(self, patient_id: int):
        self.redis.rpush(self.queue_name, patient_id)

    def remove_from_queue(self, patient_id: int):
        self.redis.lrem(self.queue_name, 0, patient_id)

    def get_queue(self):
        return [int(patient_id) for patient_id in self.redis.lrange(self.queue_name, 0, -1)]

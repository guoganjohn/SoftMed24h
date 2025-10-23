import os
import redis
from typing import List
from dotenv import load_dotenv

load_dotenv()

class QueueService:
    def __init__(self):
        self.redis_url = os.getenv("REDIS_URL")
        if self.redis_url is None:
            raise Exception("REDIS_URL environment variable is not set.")
        self.redis = redis.from_url(self.redis_url)
        self.queue_name = "patient_queue"

    def add_to_queue(self, patient_id: int):
        try:
            self.redis.rpush(self.queue_name, patient_id)
        except redis.exceptions.ConnectionError as e:
            raise Exception(f"Failed to connect to Redis: {e}") from e
        except Exception as e:
            raise Exception(f"Failed to add patient to queue: {e}") from e

    def remove_from_queue(self, patient_id: int):
        try:
            self.redis.lrem(self.queue_name, 0, patient_id)
        except redis.exceptions.ConnectionError as e:
            raise Exception(f"Failed to connect to Redis: {e}") from e
        except Exception as e:
            raise Exception(f"Failed to remove patient from queue: {e}") from e

    def get_queue(self) -> List[int]:
        try:
            return [int(patient_id) for patient_id in self.redis.lrange(self.queue_name, 0, -1)]
        except redis.exceptions.ConnectionError as e:
            raise Exception(f"Failed to connect to Redis: {e}") from e
        except Exception as e:
            raise Exception(f"Failed to retrieve queue: {e}") from e

import logging
import logging.config
import os
from src.core.config import settings

os.makedirs("logs", exist_ok=True)

logging.config.fileConfig(os.path.join(os.path.dirname(__file__), "logging.conf"))


# Configure the logger
logger = logging.getLogger("kb_profanity_apis")
logger.setLevel(settings.LOG_LEVEL)

# Example usage
# logger.debug("This is a debug message.")
# logger.info("This is an info message.")
# logger.warning("This is a warning message.")
# logger.error("This is an error message.")
# logger.critical("This is a critical message.")
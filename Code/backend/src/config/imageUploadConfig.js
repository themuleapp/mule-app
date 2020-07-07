import multer from "multer";
import { Storage } from "@google-cloud/storage";

export const initUploadInMemory = () =>
  multer({
    storage: multer.memoryStorage(),
    limits: {
      // Max 10
      fileSize: 10 * 1024 * 1024,
    },
  });

export const initCloudStorage = () =>
  new Storage({
    keyFilename: process.env.GOOGLE_CLOUD_KEY_FILE,
    projectId: process.env.GOOGLE_CLOUD_PROJECT_ID,
  });

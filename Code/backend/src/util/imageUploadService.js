import { initCloudStorage } from "../config/imageUploadConfig";
import path from "path";
import sharp from "sharp";

export const getImageForUser = async (imgLocation) => {
  const file = initCloudStorage()
    .bucket(process.env.GOOGLE_CLOUD_BUCKET_NAME)
    .file(imgLocation);
  const exists = await file.exists();

  // Weird the exists() function returns an object that is not a boolean
  if (exists.toString() == "false") {
    return null;
  }
  return file.createReadStream();
};

export const handleImageUpload = (file, _id) =>
  new Promise((resolve, reject) => {
    const { originalname } = file;
    const filename = `profile_pictures/${_id}${path.extname(originalname)}`;

    sharp(file.buffer)
      .resize(320)
      .toBuffer()
      .then((buffer) => {
        const blob = initCloudStorage()
          .bucket(process.env.GOOGLE_CLOUD_BUCKET_NAME)
          .file(filename);
        const blobStream = blob.createWriteStream({
          resumable: false,
          gzip: true,
          private: true,
        });
        blobStream
          .on("finish", () => {
            resolve(filename);
          })
          .on("error", () => {
            reject(null);
          })
          .end(buffer);
      });
  });

import multer from 'multer';
import path from 'path';
import crypto from 'crypto';

const storage = multer.diskStorage({
  destination: path.join(__dirname, '..', '..', 'images'),
  filename: async function (req, file, callback) {
    const raw = await crypto.pseudoRandomBytes(16);
    const imgName = raw.toString('hex') + path.extname(file.originalname);
    await req.user.updateProfileImageLocation(imgName);
    callback(null, imgName);

    // const userId = req.user._id;
    // console.log(userId);
    // callback(null, `${userId}${path.extname(file.originalname)}`);
  },
});

export default multer({ storage });

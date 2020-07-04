import 'regenerator-runtime/runtime.js'; // To support async await syntax
import express from 'express';
import dotenv from 'dotenv';
import morgan from 'morgan';
import cron from 'node-cron';
import swaggerJsDoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';
import bodyParser from 'body-parser';
import path from 'path';
// Our imports
import authMiddleware from './middleware/authMiddleware';
import { authRoutes, profileRoutes, verifyRoutes } from './routes/routesExport';
import registerCronJobs from './config/cronjobs';
import connectToMongo from './config/connectToMongo';
import swaggerOptions from './config/swaggerOptions';
import uploadImg from './config/imageUpload';

// setup env vars
dotenv.config();
// Register cronjobs
registerCronJobs(cron);
// Connect to DB
connectToMongo();

const app = express();
const swaggerDocs = swaggerJsDoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));
// Middleware
app.use(morgan('combined'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true, limit: '50mb' }));

app.get('/profile-image', authMiddleware, (req, res) => {
  const profileImageName = req.user.profileImageLocation;
  const location = path.join(__dirname, '..', 'images', profileImageName);
  return res.sendFile(location);
});

app.post(
  '/upload-image',
  authMiddleware,
  uploadImg.single('image'),
  (req, res) => {
    if (!req.file) {
      console.log('No file received');
      return res.send({
        success: false,
        msg: 'No file received',
      });
    } else {
      console.log('file received');
      return res.send({
        success: true,
      });
    }
  }
);

/**
 * @swagger
 * /api/test:
 *   get:
 *    summary: This should help you check if the server is alive and working.
 *    responses:
 *      200:
 *        description: Receive back property status working
 */
app.get('/api/test', (req, res) => res.send({ status: 'working' }));
app.use('/api/authentication', authRoutes);
app.use('/api/verify', verifyRoutes);
app.use('/api/profile', authMiddleware, profileRoutes);
// Only test
app.get('/api/protected', authMiddleware, async (req, res) => {
  res.send(`Authenticated ${req.token}`);
});

app.listen(process.env.PORT, err => {
  if (err) return console.log(err);
  console.log(`Server running on port ${process.env.PORT}`);
});

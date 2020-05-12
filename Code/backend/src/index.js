import express from 'express';
import dotenv from 'dotenv';
import morgan from 'morgan';
import mongoose from 'mongoose';

import authMiddleware from './middleware/authMiddleware';
// import routers
import authRouter from './routes/authentication/authRoutes';

// setup env vars
dotenv.config();

// connect to db
mongoose
  .connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log('Database connection established'))
  .catch(err =>
    console.error(`Error establishing connection to database ${err}`)
  );

const app = express();

// Middleware
app.use(morgan('combined'));
app.use(express.json());

// Register routes
app.use('/api/authentication', authRouter);
app.get('/api/protected', authMiddleware, async (req, res) => {
  res.send(`Authenticated ${req.token}`);
});

app.listen(process.env.PORT, err => {
  if (err) return console.log(err);
  console.log(`Server running on port ${process.env.PORT}`);
});

import express from 'express';
import dotenv from 'dotenv';
import morgan from 'morgan';

// import routers
import authRouter from './routes/authentication/authRoutes';

// setup env vars
dotenv.config();

const app = express();

// Middleware
app.use(morgan('combined'));
app.use(express.json());

// Register routes
app.use('/api/authentication', authRouter);

app.listen(process.env.PORT, (err) => {
  if (err) return console.log(err);
  console.log(`Server running on port ${process.env.PORT}`);
});

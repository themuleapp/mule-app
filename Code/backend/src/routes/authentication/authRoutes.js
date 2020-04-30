import { Router } from 'express';

const authRouter = Router();
// TODO add routes in here

authRouter.get('/', (req, res) => res.send('Working yo'));

export default authRouter;

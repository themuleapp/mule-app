import mongoose from 'mongoose';

export default function connectToMongo() {
  mongoose.set('useCreateIndex', true);
  mongoose
    .connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    })
    .then(() => console.log('Database connection established'))
    .catch(err =>
      console.error(`Error establishing connection to database ${err}`)
    );
}

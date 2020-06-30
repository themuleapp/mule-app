import mongoose from 'mongoose';

const deletedUserSchema = mongoose.Schema({
  email: {
    type: String,
    required: true,
    lowercase: true,
  },
  reason: {
    type: String,
    required: true,
  },
});

export default mongoose.model('DeletedUser', deletedUserSchema);

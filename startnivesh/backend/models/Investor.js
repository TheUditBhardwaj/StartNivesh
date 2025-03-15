
const mongoose = require('mongoose');

const investorSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Name is required'],
    trim: true
  },
  email: {
    type: String,
    required: [true, 'Email is required'],
    unique: true,
    trim: true,
    lowercase: true,
    match: [/^\S+@\S+\.\S+$/, 'Please provide a valid email address']
  },
  company: {
    type: String,
    trim: true
  },
  sectors: {
    type: String,
    trim: true
  },
  stagePreference: {
    type: String,
    enum: ['Pre-seed', 'Seed', 'Series A', 'Series B', 'Series C+', 'Any stage', '']
  },
  investmentRange: {
    type: String,
    enum: ['$25K - $100K', '$100K - $500K', '$500K - $1M', '$1M - $5M', '$5M+', 'Varies by opportunity', '']
  },
  expectedReturns: {
    type: String,
    enum: ['3-5x investment', '5-10x investment', '10x+ investment', 'Depends on the opportunity', '']
  },
  investmentTimeline: {
    type: String,
    enum: ['1-3 years', '3-5 years', '5-7 years', '7+ years', 'Flexible', '']
  },
  exitStrategy: {
    type: String,
    trim: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

// Update the timestamp when document is updated
investorSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Investor', investorSchema);
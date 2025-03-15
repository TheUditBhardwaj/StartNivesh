const mongoose = require('mongoose');

const startupSchema = new mongoose.Schema({
    name: { type: String, required: true },
    bio: String,
    industry: String,
    details: String,
    profileImage: String,
});

module.exports = mongoose.model('Startup', startupSchema);
const Startup = require('../models/Startup');

// Create Startup
exports.createStartup = async (req, res) => {
    try {
        const startup = new Startup(req.body);
        await startup.save();
        res.status(201).json(startup);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Get All Startups
exports.getStartups = async (req, res) => {
    try {
        const startups = await Startup.find();
        res.json(startups);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
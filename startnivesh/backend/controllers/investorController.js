
// controllers/investorController.js
const Investor = require('../models/investor');
const { validationResult } = require('express-validator');

// Create new investor profile
exports.createInvestor = async (req, res) => {
  try {
    // Validate request
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    // Create new investor
    const investor = new Investor(req.body);
    await investor.save();

    return res.status(201).json({
      success: true,
      message: 'Investor profile created successfully',
      data: investor
    });
  } catch (error) {
    if (error.code === 11000) {
      // Duplicate key error (likely email)
      return res.status(400).json({
        success: false,
        message: 'An investor with this email already exists'
      });
    }

    return res.status(500).json({
      success: false,
      message: 'Failed to create investor profile',
      error: error.message
    });
  }
};

// Get investor profile by ID
exports.getInvestor = async (req, res) => {
  try {
    const investor = await Investor.findById(req.params.id);

    if (!investor) {
      return res.status(404).json({
        success: false,
        message: 'Investor profile not found'
      });
    }

    return res.status(200).json({
      success: true,
      data: investor
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch investor profile',
      error: error.message
    });
  }
};

// Update investor profile
exports.updateInvestor = async (req, res) => {
  try {
    const investor = await Investor.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );

    if (!investor) {
      return res.status(404).json({
        success: false,
        message: 'Investor profile not found'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Investor profile updated successfully',
      data: investor
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to update investor profile',
      error: error.message
    });
  }
};

// Delete investor profile
exports.deleteInvestor = async (req, res) => {
  try {
    const investor = await Investor.findByIdAndDelete(req.params.id);

    if (!investor) {
      return res.status(404).json({
        success: false,
        message: 'Investor profile not found'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Investor profile deleted successfully'
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to delete investor profile',
      error: error.message
    });
  }
};

// Get all investors
exports.getAllInvestors = async (req, res) => {
  try {
    const investors = await Investor.find();

    return res.status(200).json({
      success: true,
      count: investors.length,
      data: investors
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch investors',
      error: error.message
    });
  }
};

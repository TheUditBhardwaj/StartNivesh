const express = require('express');
const { createStartup, getStartups } = require('../controllers/startupController');

const router = express.Router();

router.post('/startups', createStartup);
router.get('/startups', getStartups);


module.exports = router;
const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const startupRoutes = require('./routes/startupRoutes');


dotenv.config();
connectDB();

const app = express();
app.use(cors());
app.use(express.json());
app.use('/api', startupRoutes);

const PORT = process.env.PORT || 5001;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));



//const express = require('express');
//const cors = require('cors');
//const dotenv = require('dotenv');
//const connectDB = require('./config/db');
//const investorRoutes = require('./routes/investorRoutes');
//const startupRoutes = require('./routes/startupRoutes');
//
//// Load environment variables
//dotenv.config();
//
//// Initialize app
//const app = express();
//
//// Connect to database
//connectDB();
//
//// Middleware
//app.use(cors());
//app.use(express.json());
//
//// Routes
//app.use('/api/investor', investorRoutes);
//app.use('/api', startupRoutes);
//
//// Error handling middleware
//app.use((err, req, res, next) => {
//  console.error(err.stack);
//  res.status(500).json({
//    success: false,
//    message: 'Something went wrong on the server',
//    error: process.env.NODE_ENV === 'development' ? err.message : {}
//  });
//});
//
//// Start server
//const PORT = process.env.PORT || 5001;
//app.listen(PORT, () => {
//  console.log(`Server running in ${process.env.NODE_ENV || 'development'} mode on port ${PORT}`);
//});
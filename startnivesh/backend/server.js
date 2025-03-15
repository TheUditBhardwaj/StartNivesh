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
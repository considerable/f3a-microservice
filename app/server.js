const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors({
  origin: ['https://f3a-pattern-aerobatics-rc.club', 'http://localhost:3000'],
  credentials: true
}));
app.use(compression());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'f3a-microservice',
    version: '1.0.0'
  });
});

// Club information API
app.get('/api/club', (req, res) => {
  res.json({
    name: 'F3A Pattern Aerobatics RC Club',
    description: 'Precision aerobatic flying with radio-controlled aircraft',
    location: 'Pacific Northwest',
    founded: '1985',
    website: 'https://f3a-pattern-aerobatics-rc.club',
    activities: [
      'F3A Pattern Competition',
      'Training Workshops',
      'Monthly Fly-ins',
      'Equipment Reviews'
    ],
    contact: {
      email: 'info@f3a-pattern-aerobatics-rc.club',
      meetings: 'First Saturday of each month'
    }
  });
});

// Events API
app.get('/api/events', (req, res) => {
  res.json({
    upcoming: [
      {
        id: 1,
        title: 'Monthly Club Meeting',
        date: '2024-02-03',
        time: '10:00 AM',
        location: 'Club Field',
        description: 'Monthly meeting and practice session'
      },
      {
        id: 2,
        title: 'F3A Pattern Workshop',
        date: '2024-02-17',
        time: '9:00 AM',
        location: 'Club Field',
        description: 'Advanced pattern flying techniques'
      }
    ]
  });
});

// Aircraft API
app.get('/api/aircraft', (req, res) => {
  res.json({
    recommended: [
      {
        name: 'Extra 330SC',
        wingspan: '2.0m',
        weight: '4.5kg',
        engine: '120cc',
        skill_level: 'Advanced'
      },
      {
        name: 'Yak 54',
        wingspan: '1.8m',
        weight: '3.8kg',
        engine: '100cc',
        skill_level: 'Intermediate'
      }
    ]
  });
});



// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Something went wrong!',
    timestamp: new Date().toISOString()
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 F3A Microservice running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`🏠 Website: http://localhost:${PORT}`);
});

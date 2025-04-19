const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');

const app = express();
const server = http.createServer(app);

app.use(cors());

const io = new Server(server, {
  cors: {
    origin: '*', // allow all for now (adjust for production)
    methods: ['GET', 'POST']
  }
});

io.on('connection', (socket) => {
  console.log(`User connected: ${socket.id}`);

  socket.on('join_call', (data) => {
    console.log('Join call:', data);
    socket.join(data.callId);

    socket.to(data.callId).emit('user_joined', {
      userId: data.userId,
      userName: data.userName,
    });
  });

  socket.on('toggle_audio', (data) => {
    socket.to(data.callId).emit('audio_toggled', data);
  });

  socket.on('toggle_video', (data) => {
    socket.to(data.callId).emit('video_toggled', data);
  });

  socket.on('end_call', (data) => {
    socket.to(data.callId).emit('call_ended', data);
    socket.leave(data.callId);
  });

  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
    // optionally broadcast to rooms
  });
});

const PORT = 3000;
server.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
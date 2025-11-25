import express from 'express';
import { prisma } from './prisma';

const app = express();

app.get('/', async (_req, res) => {
    try {
        const users = await prisma.user.findMany({
            include: { 
                quizzes: true 
            } 
        });
        console.log('Users found:', users.length);
        res.json(users);
    } catch (err) {
        console.error('Error fetching users:', err);
        res.status(500).json({ error: 'Something went wrong fetching users' });
    }
});

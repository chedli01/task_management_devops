import { Application } from "express";
import authRoutes from "./auth.routes"
import taskRoutes from './task.routes'

export const configureRoutes = (app:Application)=>{
    app.use('/api/auth',authRoutes);
    app.use('/api/tasks', taskRoutes);
}
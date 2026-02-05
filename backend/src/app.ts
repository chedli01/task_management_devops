import express, { Application } from 'express';

const app: Application = express();

app.get('/test',(req,res)=>{
    res.json({test:'yes'})
})

export default app
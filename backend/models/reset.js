import { sequelize, User } from "./index.js";
import { hash } from "../lib/crypto.js";

await sequelize.dropAllSchemas({ force: true });
await sequelize.sync({ force: true });

// Création d'un utilisateur
const newUser = await User.create({
    username: 'Enzo',
    email: 'enzo@oclock.io',
    password: await hash('toto42oclock')
});
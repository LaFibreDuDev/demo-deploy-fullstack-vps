import { useState } from "react";
import { useUserStore } from '../store';
import { useNavigate } from 'react-router-dom';

// ne pas oublier également l'import
import fetchPost from '../utils/fetch_post';

export default function Login() {
    // traitement pour le login
    // je vais avoir besoin de maj le state user ?!
    const { user, login } = useUserStore()
    const navigate = useNavigate()

    // BONUS : on évite que l'utilisateur déjà connecté, puisse passer par là !
    if (user)
        return navigate('/')

    // Je gère les champs du formulaire

    const handleSubmit = async (e) => {
        e.preventDefault()
    
        // je récupère l'URL vers le backend (dans le .env)
        const baseUrl = import.meta.env.VITE_BACKEND_BASE_URL
        // je fais une requête vers le backend pour le login
        const data = await fetchPost(`${baseUrl}/login`, { email, password });
    
        console.log('Voici les informations générées par le serveur')
        console.log(data)
    
        if (data) {
            // JWT + Username qui seront passés depuis le backend au login
            login(data.username, data.accessToken)
            //localStorage.setItem("jwtToken", data.accessToken);
            return navigate('/')
        }
    }

    const [email, setEmail] = useState("")
    const [password, setPassword] = useState("")

    return (
        <div>
            <h1>Se connecter</h1>
            <p>C&apos;est ici que tu pourras te connecter à ton profil utilisateur !</p>
            <p>Pour tester le formulaire [enzo@oclock.io, toto42oclock]</p>
            <form method="post" onSubmit={(e) => handleSubmit(e)}>
                <fieldset>
                    <label htmlFor="email">Utilisateur</label>
                    <input
                        type="text" id="email" name="email"
                        value={email} onChange={(e) => setEmail(e.target.value)}
                    />
                </fieldset>
                <fieldset>
                    <label htmlFor="password">Mot de passe</label>
                    <input
                        type="password" id="password" name="password"
                        value={password} onChange={(e) => setPassword(e.target.value)}
                    />
                </fieldset>
                <input type="submit" value="Se connecter" />
            </form>
        </div>
    );
}
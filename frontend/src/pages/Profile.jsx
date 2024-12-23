import { useEffect, useState } from 'react'
import fetchGet from '../utils/fetch_get';
import { useUserStore } from '../store';

export default function Profile() {

    const { user } = useUserStore()
    const [profileData, setProfileData] = useState()

    const getProfile = async () => {
        console.log(user.jwtToken)
        const baseUrl = import.meta.env.VITE_BACKEND_BASE_URL
        const json = await fetchGet(`${baseUrl}/profile`, {
            credentials: "include",
            headers: {
                // Toutes les requêtes authentifiées doivent contenir le token
                "Authorization": `Bearer ${user.jwtToken}`
            }
        });
        setProfileData(json.data)
    }

    useEffect(() => {
        if (user)
            getProfile()
    }, [])

    return (
        <div>
            <h1>Ma page de profil</h1>
            <p>Mes informations personnelles</p>
            {profileData ?
                <>
                    <div>On peut voir mes informations ici s&apos;affichées</div>
                    <article style={{ marginTop: '2rem' }}>
                        <p>Mon adresse : {profileData.address.streetAddress}</p>
                        <p>Mon code postal : {profileData.address.postCode}</p>
                        <p>Ma ville : {profileData.address.city}</p>
                    </article>
                </>
                :
                <div>Accès interdit ! Il faut se connecter !</div>
            }
        </div>
    );
}
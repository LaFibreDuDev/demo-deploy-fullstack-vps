import { create } from 'zustand'

// ---------- PARTIE USER ----------------------------

export const useUserStore = create((set) => ({
    user: null,
    login: (username, jwtToken) => set(() => ({
        // todo : plus tard, on pourra aussi directement synchroniser le store avec le localStorage pour le conserver (voir la doc)
        user: { name: username, jwtToken: jwtToken }
    })),
    logout: () => set({ user: null }),
}))





// ------------ PARTIE PROJETS ------------------------

import projects from './projects'

/**
 * Récupérer la liste des projets
 * @returns la liste des projets
 */
export const getProjects = () => {
    return [...projects]
}

/**
 * Récupérer un projet via son id
 * @param {number} id l'id du projet
 * @returns un projet
 */
export const getProjectById = (id) => {
    return projects.find((project) => project.id === id)
}
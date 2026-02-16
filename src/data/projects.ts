export const TAGS = {
    ASTRO: {
        name: "Astro",
        class: "bg-[#7836cf]/20 text-[#bc95ff]",
        icon: "lucide:rocket",
    },
    REACT: {
        name: "React",
        class: "bg-[#23272f] text-[#58c4dc]",
        icon: "lucide:atom",
    },
    TAILWIND: {
        name: "Tailwind CSS",
        class: "bg-[#003159] text-white",
        icon: "lucide:wind",
    },
    NODE: {
        name: "Node.js",
        class: "bg-[#339933]/20 text-[#6cc24a]",
        icon: "lucide:server",
    },
};

export const PROJECTS = [
    {
        title: "Pronto...",
        description:
            "Aqui va la descripcion del Proyecto",
        link: "Aqui va el link del proyecto (si tiene)",
        github: "Aqui va el link del repositorio github del proyecto",
        image: "/projects/proyectimage",
        tags: [TAGS.REACT, TAGS.TAILWIND, TAGS.NODE],
    }
];

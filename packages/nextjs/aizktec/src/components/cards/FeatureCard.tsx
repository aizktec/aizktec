import Link from 'next/link';

interface FeatureCardProps {
    title: string;
    description: string;
    link: string;
}

const FeatureCard: React.FC<FeatureCardProps> = ({ title, description, link }) => {
    return (
        <div className="p-6 rounded-lg text-left border border-border bg-card text-card-foreground flex flex-col justify-between h-full">
            <h3 className="text-xl font-bold">{title}</h3>
            <p className="text-muted-foreground mt-2">{description}</p>
            <Link 
                href={link} 
                className="mt-9 inline-block w-full px-4 py-2 text-center rounded bg-primary text-primary-foreground hover:bg-primary/90 transition"
            >
                Learn more
            </Link>
        </div>
    );
};

export default FeatureCard;

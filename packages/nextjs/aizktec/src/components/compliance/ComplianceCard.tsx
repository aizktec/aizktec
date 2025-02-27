import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { cn } from "@/lib/utils";

interface ComplianceCardProps {
  children: React.ReactNode;
  title?: string;
  cardContentClassName?: string;
}

const ComplianceCard = ({
  children,
  title,
  cardContentClassName,
}: ComplianceCardProps) => {
  return (
    <Card className="bg-customGray p-4 rounded-lg text-left border border-white/30 flex flex-col justify-between h-full text-white">
      {title && (
        <CardHeader className="text-center text-2xl">
          <CardTitle className="capitalize">{title}</CardTitle>
        </CardHeader>
      )}

      <CardContent className={cn("text-center", cardContentClassName)}>
        {children}
      </CardContent>
    </Card>
  );
};

export default ComplianceCard;

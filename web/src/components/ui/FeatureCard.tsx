import React from 'react';

interface FeatureCardProps {
  title: string;
  description: string;
  icon: React.ReactNode;
  color: 'coral' | 'teal' | 'violet';
}

export function FeatureCard({ title, description, icon, color }: FeatureCardProps) {
  const bgColors = {
    coral: 'bg-coral',
    teal: 'bg-teal',
    violet: 'bg-violet',
  };

  const softColors = {
    coral: 'bg-coral/20',
    teal: 'bg-teal/20',
    violet: 'bg-violet/20',
  };

  return (
    <div className="relative bg-white rounded-[22px] border-memphis shadow-memphis p-8 overflow-hidden hover-memphis group cursor-default">
      {/* Icon Chip */}
      <div className={`w-[62px] h-[62px] rounded-2xl border-memphis shadow-memphis-sm ${bgColors[color]} flex items-center justify-center mb-6`}>
        {icon}
      </div>

      <h4 className="font-display font-bold text-2xl mb-3 leading-tight">{title}</h4>
      <p className="font-sans text-ink/80 text-[15px] leading-relaxed relative z-10">
        {description}
      </p>

      {/* Bottom right soft accent circle */}
      <div className={`absolute -bottom-12 -right-12 w-32 h-32 rounded-full ${softColors[color]} transition-transform group-hover:scale-110 z-0`} />
    </div>
  );
}

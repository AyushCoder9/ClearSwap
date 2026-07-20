import React from 'react';
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function MarkerHighlight({ 
  children, 
  color = 'mustard',
  rotation = '-2deg'
}: { 
  children: React.ReactNode, 
  color?: 'mustard' | 'teal' | 'coral' | 'violet' | 'sky',
  rotation?: string 
}) {
  const colors = {
    mustard: 'bg-mustard',
    teal: 'bg-teal',
    coral: 'bg-coral',
    violet: 'bg-violet',
    sky: 'bg-sky',
  };

  return (
    <span className="relative inline-block whitespace-nowrap z-10 px-1">
      <span 
        className={cn("absolute inset-0 z-[-1] rounded-sm", colors[color])} 
        style={{ transform: `rotate(${rotation}) scale(1.05)`, height: '80%', top: '10%' }}
      />
      {children}
    </span>
  );
}

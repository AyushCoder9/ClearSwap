import React from 'react';
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

interface CandyButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'accent';
  size?: 'sm' | 'md' | 'lg';
}

export function CandyButton({ 
  className, 
  variant = 'primary', 
  size = 'md',
  children,
  ...props 
}: CandyButtonProps) {
  const baseStyles = "inline-flex items-center justify-center font-sans font-bold border-[3px] border-ink rounded-full transition-all active:translate-x-1 active:translate-y-1";
  
  const variants = {
    primary: "bg-coral text-white shadow-[8px_8px_0_var(--color-ink)] hover:shadow-[4px_4px_0_var(--color-ink)] hover:translate-x-1 hover:translate-y-1 active:shadow-none",
    secondary: "bg-white text-ink shadow-[8px_8px_0_var(--color-ink)] hover:shadow-[4px_4px_0_var(--color-ink)] hover:translate-x-1 hover:translate-y-1 active:shadow-none",
    accent: "bg-teal text-white shadow-[5px_5px_0_var(--color-ink)] hover:shadow-[2px_2px_0_var(--color-ink)] hover:translate-x-[3px] hover:translate-y-[3px] active:shadow-none",
  };

  const sizes = {
    sm: "px-4 py-2 text-sm",
    md: "px-6 py-3 text-base",
    lg: "px-8 py-4 text-lg",
  };

  return (
    <button 
      className={cn(baseStyles, variants[variant], sizes[size], className)}
      {...props}
    >
      {children}
    </button>
  );
}

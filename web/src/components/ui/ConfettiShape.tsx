import React from 'react';

type ShapeType = 'triangle' | 'quarter-arc' | 'dotted-circle' | 'plus' | 'squiggle' | 'half-circle' | 'dot' | 'zigzag' | 'striped-circle';
type AnimationType = 'animate-drift' | 'animate-spin-slow' | 'animate-bob' | 'animate-sway';

interface ConfettiShapeProps {
  type: ShapeType;
  color: string; // e.g., 'var(--color-coral)'
  className?: string;
  animation?: AnimationType;
  size?: number;
}

export function ConfettiShape({ type, color, className = '', animation = 'animate-drift', size = 64 }: ConfettiShapeProps) {
  const renderShape = () => {
    switch (type) {
      case 'triangle':
        return <polygon points="32,4 4,60 60,60" fill={color} stroke="var(--color-ink)" strokeWidth="3" strokeLinejoin="round" />;
      case 'quarter-arc':
        return <path d="M4,60 A56,56 0 0,1 60,4 L60,60 Z" fill={color} stroke="var(--color-ink)" strokeWidth="3" strokeLinejoin="round" />;
      case 'dotted-circle':
        return (
          <circle cx="32" cy="32" r="28" fill="none" stroke={color} strokeWidth="6" strokeDasharray="6 6" />
        );
      case 'plus':
        return (
          <path d="M24,4 L40,4 L40,24 L60,24 L60,40 L40,40 L40,60 L24,60 L24,40 L4,40 L4,24 L24,24 Z" fill={color} stroke="var(--color-ink)" strokeWidth="3" strokeLinejoin="round" />
        );
      case 'squiggle':
        return (
          <path d="M4,32 C12,12 20,52 32,32 C44,12 52,52 60,32" fill="none" stroke={color} strokeWidth="6" strokeLinecap="round" strokeLinejoin="round" />
        );
      case 'half-circle':
        return <path d="M4,32 A28,28 0 0,1 60,32 Z" fill={color} stroke="var(--color-ink)" strokeWidth="3" strokeLinejoin="round" />;
      case 'dot':
        return <circle cx="32" cy="32" r="16" fill={color} stroke="var(--color-ink)" strokeWidth="3" />;
      case 'zigzag':
        return <polyline points="4,48 20,16 40,48 56,16" fill="none" stroke={color} strokeWidth="6" strokeLinecap="round" strokeLinejoin="round" />;
      case 'striped-circle':
        return (
          <>
            <defs>
              <pattern id="stripes" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
                <line x1="0" y1="4" x2="8" y2="4" stroke="var(--color-ink)" strokeWidth="2" />
              </pattern>
            </defs>
            <circle cx="32" cy="32" r="28" fill="url(#stripes)" stroke="var(--color-ink)" strokeWidth="3" />
            <circle cx="32" cy="32" r="28" fill={color} opacity="0.5" />
          </>
        );
      default:
        return null;
    }
  };

  return (
    <svg 
      width={size} 
      height={size} 
      viewBox="0 0 64 64" 
      className={`absolute ${animation} ${className}`}
      style={{ pointerEvents: 'none', zIndex: 0 }}
      xmlns="http://www.w3.org/2000/svg"
    >
      {renderShape()}
    </svg>
  );
}

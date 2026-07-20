import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import { SimulatorProvider, useSimulator } from '../src/components/providers/SimulatorProvider';

const TestComponent = () => {
  const { isOpen, currentScreen, openSimulator, closeSimulator, navigate } = useSimulator();
  return (
    <div>
      <div data-testid="is-open">{isOpen ? 'open' : 'closed'}</div>
      <div data-testid="current-screen">{currentScreen}</div>
      <button onClick={() => openSimulator('valuation')}>Open</button>
      <button onClick={() => closeSimulator()}>Close</button>
      <button onClick={() => navigate('terminal')}>Navigate</button>
    </div>
  );
};

describe('SimulatorProvider', () => {
  it('should initialize with default closed state', () => {
    render(
      <SimulatorProvider>
        <TestComponent />
      </SimulatorProvider>
    );
    expect(screen.getByTestId('is-open')).toHaveTextContent('closed');
    expect(screen.getByTestId('current-screen')).toHaveTextContent('dashboard');
  });

  it('should update state when openSimulator is called', () => {
    render(
      <SimulatorProvider>
        <TestComponent />
      </SimulatorProvider>
    );
    fireEvent.click(screen.getByText('Open'));
    expect(screen.getByTestId('is-open')).toHaveTextContent('open');
    expect(screen.getByTestId('current-screen')).toHaveTextContent('valuation');
  });

  it('should navigate to terminal', () => {
    render(
      <SimulatorProvider>
        <TestComponent />
      </SimulatorProvider>
    );
    fireEvent.click(screen.getByText('Navigate'));
    expect(screen.getByTestId('current-screen')).toHaveTextContent('terminal');
  });
});

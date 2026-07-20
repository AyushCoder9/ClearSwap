import { test, expect } from '@playwright/test';

test.describe('ClearSwap Simulator User Flow', () => {
  test('should navigate through the entire simulator happy path', async ({ page }) => {
    // 1. Navigate to localhost
    await page.goto('http://localhost:3002');
    
    // 2. Open Simulator from Hero CTA
    await page.getByRole('button', { name: 'Run Simulator' }).first().click();
    
    // 3. Verify Simulator Modal opened (Onboarding is default)
    await expect(page.getByRole('heading', { name: 'Market Intelligence' }).first()).toBeVisible();

    // 4. Skip Onboarding to go to Scan Item
    await page.getByRole('button', { name: 'Skip to App' }).click();
    await expect(page.getByRole('heading', { name: 'Scan Product' })).toBeVisible();

    // 5. Wait for scanning to finish and get valuation
    await page.waitForTimeout(3000);
    await page.getByRole('button', { name: 'Get Market Valuation' }).click();
    await expect(page.getByRole('heading', { name: 'Valuation Studio' })).toBeVisible();

    // 6. Proceed to Escrow Dashboard
    await page.getByRole('button', { name: 'Proceed to Escrow' }).click();
    await expect(page.getByRole('heading', { name: 'Dashboard' })).toBeVisible();

    // 7. Fund Escrow to go to Meetup Radar
    await page.getByRole('button', { name: 'Fund Escrow' }).click();
    await expect(page.getByRole('heading', { name: 'Meetup Radar' })).toBeVisible();

    // 8. Verify Meetup -> POS Terminal
    await page.getByRole('button', { name: 'Verify Meetup' }).click();
    await expect(page.getByRole('heading', { name: 'POS Terminal' })).toBeVisible();

    // 9. Simulate Buyer Scan -> Wallet Success
    await page.getByRole('button', { name: 'Simulate Buyer Scan' }).click();
    
    // Wait for the simulated network delay (1.5s)
    await page.waitForTimeout(2000);
    
    await expect(page.getByRole('heading', { name: 'Payment Confirmed' })).toBeVisible();
    await expect(page.getByText('Verified Receipt', { exact: true })).toBeVisible();

    // 10. Close Simulator
    await page.getByRole('button', { name: 'Done' }).click();
    
    // 11. Verify Simulator closed
    await expect(page.getByRole('heading', { name: 'Payment Confirmed' })).not.toBeVisible();
  });
});

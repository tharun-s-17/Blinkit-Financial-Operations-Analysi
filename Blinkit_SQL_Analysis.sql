-- overall financial performance by product category
-- Evaluation of Estimated Gross Profit

CREATE VIEW vw_revenue_margin AS 
SELECT 
    p.category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    ROUND(AVG(p.margin_percentage), 2) AS avg_profit_margin,
    ROUND(SUM(oi.quantity * oi.unit_price) * (AVG(p.margin_percentage) / 100), 2) AS estimated_gross_profit
FROM blinkit_order_items oi
JOIN blinkit_products p ON oi.product_id = p.product_id
GROUP BY p.category;

-- Inventory Shrinkage
-- Evaluation of loss by damaged stocks

CREATE VIEW vw_inventory_shrinkage AS
SELECT 
    p.category,
    SUM(i.stock_received) AS total_stock_received,
    SUM(i.damaged_stock) AS total_damaged_stock,
    ROUND((SUM(i.damaged_stock) / SUM(i.stock_received)) * 100, 2) AS damage_rate_percentage,
    ROUND(SUM(i.damaged_stock * (p.price * (1 - (p.margin_percentage / 100)))), 2) AS estimated_financial_loss
FROM blinkit_inventory i
JOIN blinkit_products p ON i.product_id = p.product_id
GROUP BY p.category;

-- Marketing RoI
-- Calculation of CAC & ROAS

CREATE VIEW vw_marketing_efficiency AS
SELECT 
    channel,
    SUM(spend) AS total_spend,
    SUM(revenue_generated) AS total_revenue,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(spend) / SUM(conversions), 2) AS customer_acquisition_cost_cac,
    ROUND(SUM(revenue_generated) / SUM(spend), 2) AS overall_roas
FROM blinkit_marketing_performance
GROUP BY channel;

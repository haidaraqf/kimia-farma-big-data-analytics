CREATE OR REPLACE TABLE `kf_bp.kf_analysis` AS

SELECT
    ft.transaction_id,
    ft.date,
    ft.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,

    kc.rating AS rating_cabang,

    ft.customer_name,
    ft.product_id,
    kp.product_name,

    ft.price AS actual_price,
    ft.discount_percentage,

    CASE
        WHEN ft.price <= 50000 THEN 0.10
        WHEN ft.price <= 100000 THEN 0.15
        WHEN ft.price <= 300000 THEN 0.20
        WHEN ft.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,

    ROUND(
        ft.price * (1 - ft.discount_percentage),
        2
    ) AS nett_sales,

    ROUND(
        ft.price * (1 - ft.discount_percentage) *
        CASE
            WHEN ft.price <= 50000 THEN 0.10
            WHEN ft.price <= 100000 THEN 0.15
            WHEN ft.price <= 300000 THEN 0.20
            WHEN ft.price <= 500000 THEN 0.25
            ELSE 0.30
        END,
        2
    ) AS nett_profit,

    ft.rating AS rating_transaksi

FROM `kf_bp.kf_final_transaction` AS ft

LEFT JOIN `kf_bp.kf_kantor_cabang` AS kc
    ON ft.branch_id = kc.branch_id

LEFT JOIN `kf_bp.kf_product` AS kp
    ON ft.product_id = kp.product_id;

SELECT * FROM `kf_bp.kf_analysis`LIMIT 5;

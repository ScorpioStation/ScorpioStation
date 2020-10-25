-- add a new column to track antag raffle tickets earned
ALTER TABLE player ADD antag_raffle_tickets int DEFAULT 0 AFTER lastchangelog;

CREATE TYPE games_status AS ENUM ('pending', 'ongoing', 'finished', 'aborted');
CREATE TYPE games_results AS ENUM ('0-0', '1-0', '0-1', '1/2-1/2');

CREATE TABLE IF NOT EXISTS users (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    username TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    avatar_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CHECK (char_length(username) BETWEEN 3 AND 30)
);

CREATE TABLE IF NOT EXISTS games (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    white_player_id INT REFERENCES users(id) ON DELETE SET NULL,
    black_player_id INT REFERENCES users(id) ON DELETE SET NULL,
    winner_id INT REFERENCES users(id) ON DELETE SET NULL,

    status TEXT NOT NULL DEFAULT 'pending',
    result TEXT NOT NULL DEFAULT '0-0',

    started_at TIMESTAMPTZ,
    ended_at TIMESTAMPTZ,
    moves_count INT NOT NULL DEFAULT 0,
    pgn TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CHECK (moves_count >= 0),
    CHECK (ended_at IS NULL OR started_at IS NULL OR ended_at >= started_at),
    CHECK (winner_id IS NULL OR winner_id IN (white_player_id, black_player_id)),
    CHECK (
        (status IN ('pending', 'ongoing', 'aborted') AND result = '0-0')
        OR
        (status = 'finished' AND result IN ('1-0', '0-1', '1/2-1/2'))
    )
);

CREATE INDEX IF NOT EXISTS idx_games_white_player ON games(white_player_id);
CREATE INDEX IF NOT EXISTS idx_games_black_player ON games(black_player_id);
CREATE INDEX IF NOT EXISTS idx_games_winner ON games(winner_id);
CREATE INDEX IF NOT EXISTS idx_games_started_at ON games(started_at);
CREATE INDEX IF NOT EXISTS idx_games_created_at ON games(created_at);
CREATE INDEX IF NOT EXISTS idx_games_ongoing ON games(status) WHERE status = 'ongoing';

CREATE TABLE IF NOT EXISTS game_moves (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    game_id INT NOT NULL REFERENCES games(id) ON DELETE CASCADE,
    move_number INT NOT NULL,
    san TEXT NOT NULL,
    uci TEXT,
    from_square TEXT,
    to_square TEXT,
    piece TEXT,
    captured_piece TEXT,
    comment TEXT,
    fen_before TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CHECK (move_number > 0),
    UNIQUE (game_id, move_number)
);
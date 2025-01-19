const std = @import("std");
const testing = std.testing;
const assert = std.debug.assert;

const token = @import("token.zig");
const Token = token.Token;
const TokenTypes = token.TokenTypes;

const Lexer = struct {
    input: []const u8,
    position: usize,
    read_position: usize,
    ch: u8,

    fn new(input: []const u8) Lexer {
        var l = Lexer{ .input = input, .position = 0, .read_position = 0, .ch = 0 };
        l.read_char();
        return l;
    }

    fn read_char(self: *Lexer) void {
        if (self.read_position >= self.input.len) {
            self.ch = 0;
        } else {
            self.ch = self.input[self.read_position];
        }
        self.position = self.read_position;
        self.read_position += 1;
    }

    fn next_token(self: *Lexer) Token {
        var tok: Token = undefined;

        switch (self.ch) {
            '=' => tok = Token{ .Type = TokenTypes.ASSIGN, .Literal = "=" },
            ';' => tok = Token{ .Type = TokenTypes.SEMICOLON, .Literal = ";" },
            '+' => tok = Token{ .Type = TokenTypes.PLUS, .Literal = "+" },
            '(' => tok = Token{ .Type = token.TokenTypes.LPAREN, .Literal = "(" },
            ')' => tok = Token{ .Type = TokenTypes.RPAREN, .Literal = ")" },
            ',' => tok = Token{ .Type = TokenTypes.COMMA, .Literal = "," },
            '{' => tok = Token{ .Type = TokenTypes.LBRACE, .Literal = "{" },
            '}' => tok = Token{ .Type = TokenTypes.RBRACE, .Literal = "}" },
            0 => tok = Token{ .Type = TokenTypes.EOF, .Literal = "" },
            else => {
                if (is_letter(self.ch)) {
                    return Token{ .Type = lookup_ident(self.read_identifier()), .Literal = self.read_identifier() };
                } else {
                    tok = new_token(token.TokenTypes.ILLEGAL, self.ch);
                }
            },
        }

        self.read_char();
        return tok;
    }

    fn read_identifier(self: *Lexer) []const u8 {
        const start = self.position;
        while (is_letter(self.ch)) {
            self.read_char();
        }
        return self.input[start..self.position];
    }
};

const keywords = struct {
    pub fn get(text: []const u8) ?token.TokenType {
        if (std.mem.eql(u8, text, "fn")) return token.TokenTypes.FUNCTION;
        if (std.mem.eql(u8, text, "let")) return token.TokenTypes.LET;
        return null;
    }
};

fn lookup_ident(ident: []const u8) token.TokenType {
    if (keywords.get(ident)) |tok| {
        return tok;
    }
    return token.TokenTypes.IDENT;
}

fn is_letter(ch: u8) bool {
    return std.ascii.isAlphabetic(ch) or ch == '_';
}

fn new_token(token_type: token.TokenType, ch: u8) Token {
    var literal: [1]u8 = undefined;
    literal[0] = ch;
    return Token{ .Type = token_type, .Literal = literal[0..] };
}

// tests
test "test_next_token" {
    const input = "let five = 5;let ten = 10;let add = fn(x, y) { x + y; };let result = add(five, ten);";

    const tests = [_]Token{
        Token{ .Type = token.TokenTypes.LET, .Literal = "let" },
        Token{ .Type = token.TokenTypes.IDENT, .Literal = "five" },
        Token{ .Type = token.TokenTypes.ASSIGN, .Literal = "=" },
        Token{ .Type = token.TokenTypes.INT, .Literal = "5" },
        Token{ .Type = token.TokenTypes.SEMICOLON, .Literal = ";" },
        Token{ .Type = token.TokenTypes.LET, .Literal = "let" },
        Token{ .Type = token.TokenTypes.IDENT, .Literal = "ten" },
        Token{ .Type = token.TokenTypes.ASSIGN, .Literal = "=" },
        Token{ .Type = token.TokenTypes.INT, .Literal = "10" },
        Token{ .Type = token.TokenTypes.SEMICOLON, .Literal = ";" },
        Token{ .Type = token.TokenTypes.LET, .Literal = "let" },
        Token{ .Type = token.TokenTypes.IDENT, .Literal = "add" },
        Token{ .Type = token.TokenTypes.ASSIGN, .Literal = "=" },
        Token{ .Type = token.TokenTypes.FUNCTION, .Literal = "fn" },
        Token{ .Type = token.TokenTypes.LPAREN, .Literal = "(" },
        Token{ .Type = token.TokenTypes.IDENT, .Literal = "x" },
        Token{ .Type = token.TokenTypes.COMMA, .Literal = "," },
        Token{ .Type = token.TokenTypes.IDENT, .Literal = "y" },
        Token{ .Type = token.TokenTypes.RPAREN, .Literal = ")" },
        Token{ .Type = token.TokenTypes.LBRACE, .Literal = "{" },
        Token{ .Type = token.TokenTypes.IDENT, .Literal = "x" },
        Token{ .Type = token.TokenTypes.PLUS, .Literal = "+" },
        Token{ .Type = token.TokenTypes.IDENT, .Literal = "y" },
        Token{ .Type = token.TokenTypes.SEMICOLON, .Literal = ";" },
        Token{ .Type = token.TokenTypes.LET, .Literal = "let" },
        Token{ .Type = token.TokenTypes.IDENT, .Literal = "result" },
        Token{ .Type = token.TokenTypes.ASSIGN, .Literal = "=" },
        Token{ .Type = token.TokenTypes.IDENT, .Literal = "add" },
        Token{ .Type = token.TokenTypes.LPAREN, .Literal = "(" },
        Token{ .Type = token.TokenTypes.IDENT, .Literal = "five" },
        Token{ .Type = token.TokenTypes.COMMA, .Literal = "," },
        Token{ .Type = token.TokenTypes.IDENT, .Literal = "ten" },
        Token{ .Type = token.TokenTypes.RPAREN, .Literal = ")" },
        Token{ .Type = token.TokenTypes.SEMICOLON, .Literal = ";" },
        Token{ .Type = token.TokenTypes.EOF, .Literal = "" },
    };

    var l = Lexer.new(input);

    for (tests) |tt| {
        const tok = l.next_token();
        try testing.expect(std.mem.eql(u8, tok.Type, tt.Type));
        try testing.expect(std.mem.eql(u8, tok.Literal, tt.Literal));
    }
}

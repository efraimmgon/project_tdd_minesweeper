require "game"

describe Game do
  let(:game){ Game.new }

  describe "#initialize" do
    it "has a 10x10 board by default" do
      # rows
      expect(game.board.length).to eq(10)
      # cols
      expect(game.board[0].length).to eq(10)
    end

    it "has 9 mines by default" do
      expect(game.mines).to eq(9)
    end

    it "has the same number of flags_remaining as mines" do
      expect(game.flags_remaining).to eq(game.mines)
    end
  end

  describe "#generate_mines" do
    it "returns an array of axis with equivalent number of mines" do
      expect(game.generate_mines.length).to eq(game.mines)
    end

    it "has axis that are within the boundaries of the board" do
      rows, cols = game.board.length, game.board[0].length
      x, y = game.generate_mines[0]
      expect((0...rows).include?(x)).to be(true)
      expect((0...cols).include?(y)).to be(true)
    end
  end

  describe "#plant_mines!" do
    it "plants mines on the positions given by #generate_mines" do
      positions = game.generate_mines
      game.plant_mines!(positions)
      x, y = positions.sample
      expect(game.board[x][y]).to eq(:B)
    end
  end

  describe "#render" do
    let(:string_input){ "hello world" }
    let(:array_input){ [string_input] }

    it "can handle a string as input" do
      expect{game.render(string_input)}.to output(/hello world/).to_stdout
    end

    it "can handle an array as input" do
      expect{game.render([string_input])}.to output(/hello world/).to_stdout
    end

    it "preppends a newline to the output" do
      expect{game.render(string_input)}.to output("\n#{string_input}\n").to_stdout
      expect{game.render([string_input])}.to output("\n#{string_input}\n").to_stdout
    end
  end

  describe "#clear_square!" do
    it "marks a square as :C" do
      game.clear_square!(0, 0)
      expect(game.board[0][0]).to eq(:C)
    end
  end

  describe "#place_flag!" do
    it "should place a flag on the referenced axis" do
      game.place_flag!(0, 0)
      expect(game.board[0][0]).to eq(:F)
    end

    it "should only be able to place flags on uncleared spaces" do
      game.app_state[:board][0][0] = :C
      game.app_state[:board][1][1] = :F
      game.app_state[:board][2][2] = :B
      game.app_state[:board][3][3] = nil
      expect(game.place_flag!(0, 0)).to be(false)
      expect(game.place_flag!(1, 1)).to be(false)
      expect(game.place_flag!(2, 2)).to eq(:F)
      expect(game.place_flag!(3, 3)).to eq(:F)
    end

    it "shouldn't place more flags if there are no more remaining" do
      game.app_state[:flags_remaining] = 0
      expect(game.place_flag!(0,0)).to be(false)
    end

    it "should update the remaining flag counter" do
      flags_before = game.flags_remaining
      game.place_flag!(0, 0)
      flags_after = game.flags_remaining
      expect(flags_after).to eq(flags_before - 1)
    end
  end

end

require './lib/ray_attack.rb'
require './lib/nonray_attack.rb'
require './lib/preload_moves.rb'

module Board_Threats
  include Ray_Attack
  include Nonray_Attack
  include Preload_Moves

  def init_pseudo_moves
    # generate pseudo-legal bitboards ray attacks
    @pseudo_ray_attacks = gen_ray_attacks

    # generate non-ray attack bitboards
    @knight_attacks = gen_knight_attacks
    @king_attacks = gen_king_attacks
    @w_pawn_attacks = gen_w_pawn_attacks
    @b_pawn_attacks = gen_b_pawn_attacks
  end

  def get_threats_by_color(colored_pieces, color, occupied_BB)
    ray_threats = get_all_ray_threats(colored_pieces, occupied_BB)
    nonray_threats = get_all_nonray_threats(colored_pieces, color)
    ray_threats.merge(nonray_threats)
  end

  def threat_hash_to_all_threat_BB(threat_hash)
    threat_hash.values.reduce(0) do |all_threat_BB, threat|
      threat.values.each do |threat_BB|
        bitboard = 0
        if threat_BB.is_a?(Hash) # ray threat
          bitboard = threat_BB.values.reduce(0) do |ray_threat_BB, ray_threat|
            ray_threat_BB |= ray_threat
          end
        else
          bitboard = threat_BB # nonray threat
        end
        all_threat_BB |= bitboard unless bitboard.nil?
      end
      all_threat_BB
    end
  end

  def get_all_ray_threats(colored_pieces, occupied_BB)
    ray_threats = {}
    colored_bishop_threats = get_legal_rays('bishop', colored_pieces[:bishop], @pseudo_ray_attacks, occupied_BB)
    colored_rook_threats = get_legal_rays('rook', colored_pieces[:rook], @pseudo_ray_attacks, occupied_BB)
    colored_queen_threats = get_legal_rays('queen', colored_pieces[:queen], @pseudo_ray_attacks, occupied_BB)
    ray_threats[:bishop] = colored_bishop_threats
    ray_threats[:rook] = colored_rook_threats
    ray_threats[:queen] = colored_queen_threats
    ray_threats 
  end

  def get_all_nonray_threats(colored_pieces, color)
    nonray_threats = {}
    colored_pawn_attack = (color == :white ? @w_pawn_attacks : @b_pawn_attacks)
    colored_pawn_threats = pawn_threats(colored_pieces[:pawn], colored_pawn_attack)
    colored_knight_threats = knight_threats(colored_pieces[:knight], @knight_attacks)
    colored_king_threats = king_threats(colored_pieces[:king], @king_attacks)
    nonray_threats[:pawn] = colored_pawn_threats 
    nonray_threats[:knight] = colored_knight_threats
    nonray_threats[:king] = colored_king_threats
    nonray_threats
  end
end
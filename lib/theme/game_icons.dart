import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../models/game_state.dart';
import '../models/game_status.dart';

abstract final class GameIcons {
  static const IconData pvp = LucideIcons.users;
  static const IconData aiHard = LucideIcons.bot;
  static const IconData aiMedium = LucideIcons.cpu;
  static const IconData tutorial = LucideIcons.circle_question_mark;
  static const IconData back = LucideIcons.chevron_left;
  static const IconData home = LucideIcons.house;
  static const IconData restart = LucideIcons.refresh_cw;
  static const IconData undo = LucideIcons.undo_2;
  static const IconData rules = LucideIcons.book_open;
  static const IconData info = LucideIcons.info;
  static const IconData player1 = LucideIcons.user;
  static const IconData player2 = LucideIcons.circle_user;
  static const IconData ai = LucideIcons.brain;
  static const IconData citizen = LucideIcons.circle;
  static const IconData mandarin = LucideIcons.gem;
  static const IconData debt = LucideIcons.circle_minus;
  static const IconData score = LucideIcons.trophy;
  static const IconData clockwise = LucideIcons.rotate_cw;
  static const IconData counterClockwise = LucideIcons.rotate_ccw;
  static const IconData cancel = LucideIcons.x;
  static const IconData win = LucideIcons.award;
  static const IconData tie = LucideIcons.handshake;
  static const IconData pick = LucideIcons.sparkles;
  static const IconData sow = LucideIcons.footprints;
  static const IconData capture = LucideIcons.party_popper;
  static const IconData stop = LucideIcons.circle_stop;
  static const IconData refill = LucideIcons.grid_3x3;
  static const IconData borrow = LucideIcons.credit_card;
  static const IconData square = LucideIcons.square;
  // Difficulty level badges — distinct signal-strength icons.
  static const IconData easyBadge = LucideIcons.signal_low;
  static const IconData mediumBadge = LucideIcons.signal_medium;
  static const IconData hardBadge = LucideIcons.signal_high;
  // Sow-direction arrows (clearer than rotate icons on the board).
  static const IconData sowRight = LucideIcons.move_right;
  static const IconData sowLeft = LucideIcons.move_left;
  static const IconData next = LucideIcons.arrow_right;
  static const IconData prev = LucideIcons.arrow_left;
  static const IconData play = LucideIcons.play;
  static const IconData confirm = LucideIcons.check;
  static const IconData warning = LucideIcons.triangle_alert;
  static const IconData board = LucideIcons.layout_grid;
  static const IconData flag = LucideIcons.flag;

  static IconData forMode(GameMode mode) {
    switch (mode) {
      case GameMode.localPvP:
        return pvp;
      case GameMode.vsEasyAI:
      case GameMode.vsMediumAI:
      case GameMode.vsHardAI:
        return ai;
    }
  }

  static IconData forStatus(StatusKind kind) {
    switch (kind) {
      case StatusKind.pick:
        return pick;
      case StatusKind.sow:
        return sow;
      case StatusKind.capture:
        return capture;
      case StatusKind.stop:
        return stop;
      case StatusKind.refill:
        return refill;
      case StatusKind.borrow:
        return borrow;
      case StatusKind.turn:
        return player1;
      case StatusKind.gameOver:
        return win;
      case StatusKind.idle:
        return info;
    }
  }

  static String semanticsLabel(IconData icon) => _labels[icon] ?? 'Hành động';

  static final Map<IconData, String> _labels = {
    pvp: 'Chơi hai người',
    aiHard: 'Đấu máy khó',
    aiMedium: 'Đấu máy thường',
    tutorial: 'Hướng dẫn',
    back: 'Quay lại',
    home: 'Về menu',
    restart: 'Chơi lại',
    undo: 'Hoàn tác',
    rules: 'Luật chơi',
    info: 'Thông tin',
    player1: 'Người chơi 1',
    player2: 'Người chơi 2',
    ai: 'Máy đối thủ',
    citizen: 'Dân',
    mandarin: 'Quan',
    debt: 'Nợ điểm',
    score: 'Điểm',
    clockwise: 'Chiều thuận',
    counterClockwise: 'Chiều ngược',
    cancel: 'Hủy',
    win: 'Chiến thắng',
    tie: 'Hòa',
    pick: 'Nhặt quân',
    sow: 'Rải quân',
    capture: 'Ăn quân',
    stop: 'Dừng lượt',
    refill: 'Rải sân',
    borrow: 'Mượn điểm',
    square: 'Ô cờ',
    easyBadge: 'Dễ',
    mediumBadge: 'Thường',
    hardBadge: 'Khó',
    sowRight: 'Rải sang phải',
    sowLeft: 'Rải sang trái',
    next: 'Tiếp theo',
    prev: 'Bước trước',
    play: 'Chơi ngay',
    confirm: 'Xác nhận',
    warning: 'Cảnh báo',
    board: 'Bàn cờ',
    flag: 'Trò chơi dân gian Việt Nam',
  };
}
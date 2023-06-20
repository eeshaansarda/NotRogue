class Dungeon {

    Player player; // Lost all previous efforts TODO
    ArrayList<Area> rooms;
    ArrayList<Area> corridors;
    ArrayList<Item> items;
    ArrayList<Monster> monsters;

    ArrayList<Area> playableArea;

    public Dungeon (float w, float h, int level) {
        rooms = new ArrayList<Area>();
        corridors = new ArrayList<Area>();
        items = new ArrayList<Item>();
        monsters = new ArrayList<Monster>();

        DungeonArea darea = new DungeonArea(w, h);
        darea.getRooms(rooms);

        createCorridors();
        createItems();
        createMonsters(level);

        playableArea = getPlayableArea();

        print("Rooms: " + rooms + "\nCorridors: " + corridors + "\nBoth: " + playableArea);

        PVector centerPosition = rooms.get(0).center();
        player = new Player(centerPosition.x, centerPosition.y);
    }

    void createCorridors() {
        for (int i = 0; i < rooms.size() - 1; i++) {
            createCorridor(rooms.get(i), rooms.get(i+1));
        }
    }


    void display() {
        for (Area room : rooms) {
            room.display();
        }
        for (Area corridor : corridors) {
            corridor.display();
        }
        for (Monster monster : monsters) {
            monster.display();
            monster.integrate(player); // move monsters
        }
        for (Item item : items) {
            item.display();
        }
        player.display();
    }


    ArrayList<Area> getPlayableArea() {
        ArrayList<Area> playableArea = new ArrayList<>(rooms);
        playableArea.addAll(new ArrayList<>(corridors));
        return playableArea;
    }

    void movePlayer(float x, float y) {
        player.move(x, y, playableArea, items, monsters);
    }

    void createItems() {
        for (Area area : rooms) {
            int numberOfItems = int(random(2, 5));
            for (int i = 0; i < numberOfItems; i++) {
                float x = random(area.coordinate.x + tileWidth*2, area.coordinate.x + area.w - tileWidth*2);
                float y = random(area.coordinate.y + tileHeight*2, area.coordinate.y + area.h - tileHeight*2);

                Pickable pickable = Pickable.values()[(int) random(Pickable.values().length - 1)]; // - 1 since we don't want to have gates somewhere else

                items.add(new Item(x, y, pickable));
            }
        }
        Area lastRoom = rooms.get(rooms.size()-1);
        float x = random(lastRoom.coordinate.x + tileWidth*2, lastRoom.coordinate.x + lastRoom.w - tileWidth*2);
        float y = random(lastRoom.coordinate.y + tileHeight*2, lastRoom.coordinate.y + lastRoom.h - tileHeight*2);

        Pickable pickable = Pickable.GATE; // add gate to go to next level

        items.add(new Item(x, y, pickable));
    }

    void createMonsters(int level) {
        for (Area area : rooms) {
            if (!rooms.get(0).equals(area)) {
                int numberOfMonsters = int(random(2, 4));
                for (int i = 0; i < numberOfMonsters; i++) {
                    float x = random(area.coordinate.x + tileWidth*2, area.coordinate.x + area.w - tileWidth*2);
                    float y = random(area.coordinate.y + tileHeight*2, area.coordinate.y + area.h - tileHeight*2);

                    monsters.add(new Monster(x, y, area, level));
                }
            }
        }
    }


    void createCorridor(Area one, Area two) {
        float corridor_width = 50;
        boolean case3L = false;
        boolean case3R = false;
        boolean top = false;
        float x, y;
        float x2, y2;

        float[] xArray = xIntersect(one, two);
        float[] yArray = yIntersect(one, two);
        float[] zeroArray = {0, 0};
        if (!Arrays.equals(xArray, zeroArray) && xArray[1] - xArray[0] > corridor_width) {
            // pick midpoint
            // half width above
            // half below.
            // total gives x
            do x = random(xArray[0], xArray[1]);
            while (x + corridor_width > xArray[1]);

            x2 = x + corridor_width;

            if (two.coordinate.y > one.coordinate.y + one.h) {
                y = one.coordinate.y + one.h;
                y2 = two.coordinate.y;
            } else {
                y = one.coordinate.y;
                y2 = two.coordinate.y + two.h;
            }
        } else if (!Arrays.equals(yArray, zeroArray) && yArray[1] - yArray[0] > corridor_width) {
            do y = random(yArray[0], yArray[1]);
            while (y + corridor_width > yArray[1]);

            y2 = y + corridor_width;

            if (two.coordinate.x > one.coordinate.x + one.w) {
                x = one.coordinate.x + one.w;
                x2 = two.coordinate.x;
            } else {
                x = one.coordinate.x;
                x2 = two.coordinate.x + two.w;
            }
        } else {
            //case3 = true;
            do x2 = two.coordinate.x + random(two.w);
            while (x2 + corridor_width > two.coordinate.x + two.w);

            if (two.coordinate.y + two.h < one.coordinate.y) y2 = two.coordinate.y + two.h;

            else {
                top = true;
                y2 = two.coordinate.y;
            }

            do y = one.coordinate.y + random(one.h);
            while (y + corridor_width > one.coordinate.y + one.h);

            // 1 on the left and 2 on the right
            if (one.coordinate.x + one.w < two.coordinate.x) {
                x = one.coordinate.x + one.w;
                case3L = true;
            }
            // 1 on the right and 2 on the left
            else {
                case3R = true;
                x = one.coordinate.x;
            }
        }

        if (case3L) {
            corridors.add(new Area(x, y, x2 - x, corridor_width));
            if (top) {
                corridors.add(new Area(x2, y, corridor_width, y2 - y));
            } else {
                print("bottom left to top right ");
                corridors.add(new Area(x2, y2, corridor_width, y + corridor_width - y2));
            }
        } else if (case3R) {
            corridors.add(new Area(x2, y, x - x2, corridor_width));
            if (top) {
                //print("top right to bottom left ");
                corridors.add(new Area(x2, y, corridor_width, y2 - y));
            } else {
                //print("bottom right to top left ");
                corridors.add(new Area(x2, y2, corridor_width, y2 -y));
            }
        } else corridors.add(new Area(x, y, x2 - x, y2 - y));
    }

    float[] xIntersect(Area room1, Area room2) {
        float[] result = {0, 0};
        if (room1.coordinate.x > room2.coordinate.x && room1.coordinate.x + room1.w < room2.coordinate.x + room2.w) {
            result[0] = room1.coordinate.x;
            result[1] = room1.coordinate.x + room1.w;
        } else if (room2.coordinate.x > room1.coordinate.x && room2.coordinate.x + room2.w < room1.coordinate.x + room1.w) {
            result[0] = room2.coordinate.x;
            result[1] = room2.coordinate.x + room2.w;
        } else if (room1.coordinate.x < room2.coordinate.x && room1.coordinate.x + room1.w > room2.coordinate.x) {
            result[0] = room2.coordinate.x;
            result[1] = room1.coordinate.x + room1.w;
        } else if (room2.coordinate.x < room1.coordinate.x && room2.coordinate.x + room2.w > room1.coordinate.x) {
            result[0] = room1.coordinate.x;
            result[1] = room2.coordinate.x + room2.w;
        }
        return result;
    }

    float[] yIntersect(Area room1, Area room2) {
        float[] result = {0, 0};
        if (room2.coordinate.y > room1.coordinate.y && room2.coordinate.y + room2.h < room1.coordinate.y + room1.h) {
            result[0] = room2.coordinate.y;
            result[1] = room2.coordinate.y + room2.h;
        } else if (room1.coordinate.y > room2.coordinate.y && room1.coordinate.y + room1.h < room2.coordinate.y + room2.h) {
            result[0] = room1.coordinate.y;
            result[1] = room1.coordinate.y + room1.h;
        } else if (room1.coordinate.y < room2.coordinate.y && room1.coordinate.y + room1.h > room2.coordinate.y) {
            result[0] = room2.coordinate.y;
            result[1] = room1.coordinate.y + room1.h;
        } else if (room2.coordinate.y < room1.coordinate.y && room2.coordinate.y + room2.h > room1.coordinate.y) {
            result[0] = room1.coordinate.y;
            result[1] = room2.coordinate.y + room2.h;
        }
        return result;
    }
}

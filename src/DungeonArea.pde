class DungeonArea {

    DungeonArea split1, split2;
    Area room;

    float w, h;
    PVector coordinate;

    public DungeonArea (float w, float h) {
        this(0, 0, w, h);
    }

    private DungeonArea (float x, float y, float w, float h) {
        this.w = w;
        this.h = h;

        coordinate = new PVector(x, y);

        //create areas for rooms
        boolean isHorizontal = random(2) < 1;
        if (w > h && w / h > 1.25) {
            isHorizontal = false;
        } else if (h > w && h / w > 1.25) {
            isHorizontal = true;
        }

        float value = getRandom(isHorizontal);
        // too small to cut it more
        if (value != 0) {
            if (isHorizontal) {
                split1 = new DungeonArea(coordinate.x, coordinate.y, w, value - coordinate.y);
                split2 = new DungeonArea(coordinate.x, value, w, h - value);
            } else {
                split1 = new DungeonArea(coordinate.x, coordinate.y, value - coordinate.x, h);
                split2 = new DungeonArea(value, coordinate.y, w - value, h);
            }
        }
        // otherwise is a leaf node
        else {
            createRoom();
        }
    }

    void displayAreas() {
        if (split1 != null) {
            split1.displayAreas();
            split2.displayAreas();
            return;
        }
        strokeWeight(1);
        stroke(255);
        noFill();
        rect(coordinate.x, coordinate.y, w, h);
    }

    void getRooms(ArrayList<Area> rooms) {
        if (split1 == null) {
            rooms.add(room);
            return;
        }
        split1.getRooms(rooms);
        split2.getRooms(rooms);
    }

    float getRandom(boolean isHorizontal) {
        float start, end;

        if (isHorizontal) {
            start = coordinate.y + MAX_AREA_HEIGHT;
            end = h - MAX_AREA_HEIGHT;
        } else {
            start = coordinate.x + MAX_AREA_WIDTH;
            end = w - MAX_AREA_WIDTH;
        }

        if (start > end) return 0;
        return random(start, end);
    }

    void createRoom() {
        // TODO
        float roomW = random(w/2 - MAX_AREA_WIDTH) + MAX_AREA_WIDTH;
        float roomH = random(h/2 - MAX_AREA_HEIGHT) + MAX_AREA_HEIGHT;
        float roomX = random(w - roomW);
        float roomY = random(h - roomH);
        room = new Area(coordinate.x + roomX, coordinate.y + roomY, roomW, roomH);
    }
}

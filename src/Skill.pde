enum Skill {
    GROWL(0),
    BITE(10),
    SCRATCH(5),
    PUNCH(5),
    CUT(7),
    SLASH(10),
    THREESWORDSTYLE(100);
    
    float damage;
    Skill(float damage) {
        this.damage = damage;
    }
}

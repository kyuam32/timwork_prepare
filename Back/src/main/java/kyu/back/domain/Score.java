package kyu.back.domain;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Embeddable;

@Embeddable
@Getter
@Setter
public class Score {

    private int frequency;
    private int intensity;

    public Score() {
    }

    public Score(int frequency, int intensity) {
        this.frequency = frequency;
        this.intensity = intensity;
    }
}

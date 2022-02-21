package kyu.back.domain.Process;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;

@Entity
@Getter
@AllArgsConstructor
@NoArgsConstructor
@DiscriminatorColumn(name = "custom")
public class CustomProcess extends Process{
}

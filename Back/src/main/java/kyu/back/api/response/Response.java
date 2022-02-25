package kyu.back.api.response;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class Response <T>{
//    private String status;
    private String error;
    private String message;
    private T data;
}

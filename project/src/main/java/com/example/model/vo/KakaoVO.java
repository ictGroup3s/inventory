package com.example.model.vo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.ToString;

@ToString
@JsonIgnoreProperties(ignoreUnknown = true) // 응답에 내가 정의하지 않은 필드가 있어도 무시
public class KakaoVO {

    private Long id;

    @JsonProperty("connected_at")
    private String connectedAt;

    @JsonProperty("kakao_account")
    private KakaoAccount kakaoAccount;

    // getter & setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getConnectedAt() {
        return connectedAt;
    }

    public void setConnectedAt(String connectedAt) {
        this.connectedAt = connectedAt;
    }

    public KakaoAccount getKakaoAccount() {
        return kakaoAccount;
    }

    public void setKakaoAccount(KakaoAccount kakaoAccount) {
        this.kakaoAccount = kakaoAccount;
    }

    // 내부 클래스: 카카오 계정 정보
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class KakaoAccount {
        private Boolean profileNeedsAgreement;
        private Profile profile;
        private String email;

        // getter & setter
        public Boolean getProfileNeedsAgreement() {
            return profileNeedsAgreement;
        }

        public void setProfileNeedsAgreement(Boolean profileNeedsAgreement) {
            this.profileNeedsAgreement = profileNeedsAgreement;
        }

        public Profile getProfile() {
            return profile;
        }

        public void setProfile(Profile profile) {
            this.profile = profile;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }
    }

    // 내부 클래스: 프로필 정보
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Profile {
        private String nickname;

        @JsonProperty("thumbnail_image_url")
        private String thumbnailImageUrl;

        @JsonProperty("profile_image_url")
        private String profileImageUrl;

        // getter & setter
        public String getNickname() {
            return nickname;
        }

        public void setNickname(String nickname) {
            this.nickname = nickname;
        }

        public String getThumbnailImageUrl() {
            return thumbnailImageUrl;
        }

        public void setThumbnailImageUrl(String thumbnailImageUrl) {
            this.thumbnailImageUrl = thumbnailImageUrl;
        }

        public String getProfileImageUrl() {
            return profileImageUrl;
        }

        public void setProfileImageUrl(String profileImageUrl) {
            this.profileImageUrl = profileImageUrl;
        }
    }
    
    
}